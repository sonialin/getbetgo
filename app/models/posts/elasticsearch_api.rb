class Posts::ElasticsearchApi < ::Post
  include PostsHelper
  INDEX_NAME = "posts"
  TYPE_NAME = "post"

  def create_index
    delete_index
    client = create_client
    client.indices.create index: INDEX_NAME,
                          body: {
                            settings: {
                              index: {
                                number_of_shards: 1,
                                number_of_replicas: 1
                              },
                              analysis: {
                                tokenizer: {
                                  ngram_tokenizer: {
                                    type: "nGram",
                                    min_gram: 2,
                                    max_gram: 50
                                  }
                                },
                                analyzer: {
                                  index_analyzer: {
                                    type: "custom",
                                    tokenizer: "ngram_tokenizer",
                                    filter: ["standard", "my_delimiter", "lowercase", "stop", "asciifolding", "porter_stem"]
                                  },
                                  search_analyzer: {
                                    tokenizer: "standard",
                                    filter: ["standard", "lowercase", "stop", "asciifolding", "porter_stem"]
                                  }
                                },
                                filter: {
                                  my_delimiter: {
                                    type: "word_delimiter",
                                    generate_word_parts: true,                
                                    catenate_words: true,
                                    catenate_numbers: true,
                                    catenate_all: true,
                                    split_on_case_change: true,
                                    preserve_original: true,
                                    split_on_numerics: true,
                                    stem_english_possessive: true
                                  }
                                }
                              }
                            },
                            mappings: {
                              "#{TYPE_NAME}" => {
                                properties: {
                                  id: {
                                    type: 'integer'
                                  },
                                  slug: {
                                    type: 'string',
                                    index: 'not_analyzed'
                                  },
                                  category: {
                                    type: 'string',
                                    boost: 1.5,
                                    index: "analyzed",
                                    index_analyzer: "index_analyzer",
                                    search_analyzer: "search_analyzer", 
                                  },
                                  subcategory: {
                                    type: 'string',
                                    boost: 2.5,
                                    index: "analyzed",
                                    index_analyzer: "index_analyzer",
                                    search_analyzer: "search_analyzer", 
                                  },
                                  price: {
                                    type: 'float'
                                  },
                                  total_quantity: {
                                    type: 'integer'
                                  },
                                  criteria: {
                                    type: 'string',
                                    boost: 7.0,
                                    index: "analyzed",
                                    index_analyzer: "index_analyzer",
                                    search_analyzer: "search_analyzer",
                                  },
                                  description: {
                                    type: 'string',
                                    boost: 1.0,
                                    index: "analyzed",
                                    index_analyzer: "index_analyzer",
                                    search_analyzer: "search_analyzer",
                                  },
                                  quantity_left: {
                                    type: 'integer'
                                  },
                                  funder_id: {
                                    type: 'integer'
                                  },
                                  funder_name: {
                                    type: 'string',
                                    index: 'not_analyzed'
                                  },
                                  city_id: {
                                    type: 'integer'
                                  },
                                  coordinates: {
                                    type: 'geo_point'
                                  },
                                  tags: {
                                    type: 'string',
                                    boost: 4.0,
                                    index: "analyzed",
                                    index_analyzer: "index_analyzer",
                                    search_analyzer: "search_analyzer",                                    
                                  },
                                  category_id: {
                                    type: 'integer'
                                  },
                                  subcategory_id: {
                                    type: 'integer'
                                  },
                                  tag_ids: {
                                    type: 'integer'
                                  },
                                  created_at: {
                                    type: 'date'
                                  },
                                  percentage_claimed: {
                                    type: 'float'
                                  },
                                  medium_image_url: {
                                    type: 'string',
                                    index: 'not_analyzed'
                                  },
                                  funder_avatar: {
                                    type: 'string',
                                    index: 'not_analyzed'
                                  },
                                  funder_avatar_thumb: {
                                    type: 'string',
                                    index: 'not_analyzed'
                                  },
                                  funder_kudos: {
                                    type: 'integer'
                                  },
                                  funder_posts_count: {
                                    type: 'integer'
                                  },
                                  funder_contributions: {
                                    type: 'integer'
                                  },
                                  identifier: {
                                    type: 'string',
                                    index: 'not_analyzed'
                                  },
                                  published: {
                                    type: 'boolean'
                                  }
                                }
                              }
                            }
                          }
  end

  def delete_index
    client = create_client
    if client.indices.exists index: "#{INDEX_NAME}"
      client.indices.delete index: "#{INDEX_NAME}"
    end
  end

  def insert_post(post_id)
    post = Post.find(post_id)
    client = create_client
    medium_image_url = (post.image_file_size) ? post.image.url(:medium) : post_placeholder_image(post.category, post.subcategory)
    funder_avatar = post.user.user_info.avatar.url(:medium)
    funder_avatar_thumb = post.user.user_info.avatar.url(:thumb)
    client.index  index: INDEX_NAME,
                  type: TYPE_NAME,
                  id: post_id,
                  body: {
                    id: post_id,
                    slug: post.slug,
                    category: post.category.name,
                    subcategory: post.subcategory.name,
                    price: post.price.to_f,
                    total_quantity: post.quantity,
                    criteria: post.criteria,
                    description: post.description,
                    quantity_left: post.quantity - post.bets_past_selection.count,
                    funder_id: post.user_id,
                    funder_name: post.user.name,
                    city_id: post.city_id,
                    coordinates: [post.city.longitude, post.city.latitude],
                    tags: post.tag_list,
                    category_id: post.category_id,
                    subcategory_id: post.subcategory_id,
                    tag_ids: post.tag_ids,
                    created_at: post.created_at,
                    percentage_claimed: post.percentage_claimed.to_f,
                    medium_image_url: medium_image_url,
                    funder_avatar: funder_avatar,
                    funder_avatar_thumb: funder_avatar_thumb,
                    funder_kudos: post.user.kudos,
                    funder_posts_count: post.user.posts.count,
                    funder_contributions: post.user.contributions.ceil,
                    funder_identifier: post.user.identifier,
                    published: post.published
                  }
  end

  def delete_post(post_id)
    client = create_client
    if client.exists index: INDEX_NAME, type: TYPE_NAME, id: post_id
      client.delete index: INDEX_NAME,
                    type: TYPE_NAME,
                    id: post_id
    end
  end

  def create_client
    host = Figaro.env["ES_HOST"]
    port = Figaro.env["ES_PORT"]

    if Rails.env.production? or Rails.env.staging?
      Elasticsearch::Client.new url: ENV['BONSAI_URL']
    else
      return Elasticsearch::Client.new(host: host,port: port)
    end
  end

  def get_count(query)
    client = create_client
    query["size"] = 0
    response = client.search index: INDEX_NAME,
                            type: TYPE_NAME,
                            body: query
    return response["hits"]["total"]
  end

  def search(query)
    client = create_client
    response = client.search index: INDEX_NAME,
                            type: TYPE_NAME,
                            body: query
    response["hits"]["hits"].map{|t| t["_source"]}
  end

  def add_from_or_size(query, from, size)
    query["from"] = from
    query["size"] = size
    return query
  end

  def build_es_query(params, apply_pubished_filter = false)
    query = {
      "filter"=> {
        "and"=> {
          "filters"=> [
          ]
        }
      }
    }

    query = add_search_query(query, params[:search]) if params[:search] 

    category_id = Category.find_by_name(params[:category]).id rescue nil if params[:category]
    query = add_category_filter(query, category_id) if category_id

    subcategory_id = Subcategory.find_by_name(params[:subcategory]).id rescue nil if params[:subcategory]
    query = add_subcategory_filter(query, subcategory_id) if subcategory_id

    city_id = City.find_by_full_name(params[:location]).id rescue nil if params[:location]
    query = add_city_filter(query, city_id) if city_id

    tag_id = ActsAsTaggableOn::Tag.find_by_name(params[:tag]).id rescue nil if params[:tag]
    query = add_tag_filter(query, tag_id) if tag_id

    query = add_funder_filter(query, params[:funder_id]) if params[:funder_id]

    query = add_sort_by_created_at(query) unless params[:search]

    query = add_published_filter(query) if apply_pubished_filter
    return query
  end

  def add_or_filters_block(query)
    or_filters_block = {
      "or"=> []
    }
    query["filter"]["and"]["filters"].push(or_filters_block)
    return query
  end

  def add_search_query(query, search)
    query["query"] =   {
      "multi_match"=> {
        "query"=> search,
        "operator"=> "or",
        "fields"=> [ "criteria", "tags", "description", "category", "subcategory" ]
      }
    }
    return query
  end

  def add_category_filter(query, category_id)
    category_filter = {
      "term"=> {
        "category_id"=> category_id
      }
    }
    query["filter"]["and"]["filters"].push(category_filter)
    return query
  end

  def add_published_filter(query)
    published_filter = {
      "term"=> {
        "published"=> true
      }
    }
    query["filter"]["and"]["filters"].push(published_filter)
    return query
  end

  def add_subcategory_filter(query, subcategory_id)
    subcategory_filter = {
      "term"=> {
        "subcategory_id"=> subcategory_id
      }
    }
    query["filter"]["and"]["filters"].push(subcategory_filter)
    return query
  end

  def add_city_filter(query, city_id)
    city_filter = {
      "term"=> {
        "city_id"=> city_id
      }
    }
    query["filter"]["and"]["filters"].push(city_filter)
    return query
  end

  def add_tag_filter(query, tag_id)
    tag_filter = {
      "term"=> {
        "tag_ids"=> tag_id
      }
    }
    query["filter"]["and"]["filters"].push(tag_filter)
    return query
  end

  def add_funder_filter(query, funder_id)
    funder_filter = {
      "term"=> {
        "funder_id"=> funder_id
      }
    }
    query["filter"]["and"]["filters"].push(funder_filter)
    return query
  end

  def add_sort_by_created_at(query)
    query["sort"] = {
      "created_at"=> "desc"
    }
    return query
  end

  def add_lat_long_filter(query, lat_long)
    lat_long_filter = {
      "geo_distance"=> {
        "distance"=> "30km",
        "coordinates"=> lat_long.reverse
      }
    }
    query["filter"]["and"]["filters"].last["or"].push(lat_long_filter)
    return query
  end

  def add_not_lat_long_filter(query, lat_long)
    not_lat_long_filter = {
      "not"=> {
        "geo_distance"=> {
          "distance"=> "30km",
          "coordinates"=> lat_long.reverse
        }
      }
    }
    query["filter"]["and"]["filters"].push(not_lat_long_filter)
    return query
  end

  def add_followed_ids_filter(query, followed_ids)
    followed_ids_filter = {
      "terms"=> {
        "funder_id"=> followed_ids
      }
    }
    query["filter"]["and"]["filters"].last["or"].push(followed_ids_filter)
    return query
  end

  def add_not_followed_ids_filter(query, followed_ids)
    not_followed_ids_filter = {
      "not"=> {
        "terms"=> {
          "funder_id"=> followed_ids
        }
      }
    }
    query["filter"]["and"]["filters"].push(not_followed_ids_filter)
    return query
  end
end
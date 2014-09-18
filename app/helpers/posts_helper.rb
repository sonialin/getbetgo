module PostsHelper
	POSTS_PER_PAGE = 12
	def reformatted_post_datetime(time_created_at)
	  distance = Time.zone.now - time_created_at

	  format_for_old_posts = time_created_at.strftime("%m-%d-%Y")

	  format_for_fresh_posts = distance_of_time_in_words_to_now(time_created_at) + " ago"
	   
	  if(distance > 10.days)
	    format_for_old_posts
	  else
	    format_for_fresh_posts
	  end
	end

	def post_category_icon(category)
		if category == 'Business'
			raw("<i class='fa fa-briefcase'></i>")
		elsif category == 'Creative'
			raw("<i class='fa fa-video-camera'></i>")
		elsif category == 'Education'
			raw("<i class='fa fa-graduation-cap'></i>")
		elsif category == 'Lifestyle'
			raw("<i class='fa fa-coffee'></i>")
		elsif category == 'Social Impact'
			raw("<i class='fa fa-heart'></i>")
		elsif category == 'Tech'
			raw("<i class='fa fa-laptop'></i>")
		end			
	end

  def post_placeholder_image(category)
    if category.name == 'Business'
      "http://res.cloudinary.com/dxytnnzk9/image/upload/v1409231761/stsf_background_rba10x.jpg"
    elsif category.name == 'Creative'
      "http://res.cloudinary.com/dxytnnzk9/image/upload/v1409231755/IMG_1280_copy_mptqt5.jpg"
    elsif category.name == 'Animals'
      "http://www.freeallimages.com/wp-content/uploads/2014/09/grumpy-cat-no-3.jpg"
    elsif category.name == 'Lifestyle'
      "http://res.cloudinary.com/dxytnnzk9/image/upload/v1409231793/imagebase11_29_qjvqae.jpg"
    elsif category.name == 'Technology'
      "http://res.cloudinary.com/dxytnnzk9/image/upload/v1409239784/ehh-630-woman-laptop-coffee-istock-630w_tb64i9.jpg"
    elsif category.name == 'Other'
      "http://res.cloudinary.com/dxytnnzk9/image/upload/v1409231743/3814721488_c344952c7b_avvg9g.jpg"
    end     
  end

	def fetch_page_posts(posts, page)
    city = request.location.city
    country = request.location.country
		per_page = POSTS_PER_PAGE
		followed_ids = current_user.followeds.pluck(:id) if current_user

    nearby_posts = Post.where(:id => [])
    locality = Locality.where("lower(name) = ?",city.downcase).first
    nearby_posts = locality.posts if locality
    country = Country.where("lower(name) = ?",country.downcase).first
    nearby_posts = country.posts if (country && nearby_posts.count == 0)
    
    rec_or_fol_posts = posts.where("posts.user_id IN (?) OR posts.id IN (?)", followed_ids,nearby_posts.select("id")).order("posts.id desc")
    rec_or_fol_posts_ids = rec_or_fol_posts.pluck("posts.id")
    rec_or_fol_posts_count = rec_or_fol_posts_ids.count
    other_posts = posts.order("updated_at desc")
    other_posts = posts.where("posts.id NOT IN (?)",rec_or_fol_posts_ids) if rec_or_fol_posts_count > 0
    rec_or_fol_posts = rec_or_fol_posts.limit(per_page).offset((page-1)*per_page)
    rem_count = page * per_page - rec_or_fol_posts_count

    if rem_count > 0
      other_posts_offset = (rem_count > per_page) ? rem_count - per_page : 0
      other_posts_limit = (rem_count > per_page) ? per_page : rem_count
      other_posts = other_posts.limit(other_posts_limit).offset(other_posts_offset)
    else
      other_posts = []
    end

    if posts.count > page * per_page
      next_page = true 
    else 
      next_page = false
    end

    posts = rec_or_fol_posts + other_posts
    post_type = []

    rec_or_fol_posts.each do |post|
      if nearby_posts.where(:id => post.id).first
        post_type << 'r'
      else
        post_type << 'f'
      end
    end

    other_posts.each do |post|
      post_type << 'o'
    end

    return posts,post_type,next_page
	end
end

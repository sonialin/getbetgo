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

  def post_placeholder_image(category, subcategory)
    if category.name == 'Animals'
      if subcategory.name == 'Petcare'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411229753/animals_petcare_jl0emn.jpg"
      elsif subcategory.name == 'Pet Hotels'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411229750/animals_hotel_gnznpo.jpg"
      elsif subcategory.name == 'Pet Giveaways'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411229742/animals_giveaways_ebfhye.jpg"
      elsif subcategory.name == 'Help Someone Obtain a Pet'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411229747/animals_help_obtain_pet_swn08t.jpg"
      end 
    elsif category.name == 'Business'
      if subcategory.name == 'Miscellaneous'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411230246/business_misc_n8y54w.jpg"
      elsif subcategory.name == 'Marketing/ PR'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411230256/business_PR_fgj4hh.jpg"
      elsif subcategory.name == 'Technology'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411230262/business_technology_nq2bzc.jpg"
      elsif subcategory.name == 'Graphic Design'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411230235/business_design_juycmw.jpg"
      elsif subcategory.name == 'Sales'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411230259/business_sales_v5ek7b.jpg"
      elsif subcategory.name == 'Customer Service'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411230232/business_customer_vftrzo.jpg"
      elsif subcategory.name == 'Administration'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411229755/business_admin_zfd3a0.jpg"
      elsif subcategory.name == 'Finance'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411230239/business_finance_fryykr.jpg"
      end
    elsif category.name == 'Creative'
      if subcategory.name == 'Art'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232274/creative_art_y1a9wz.jpg"
      elsif subcategory.name == 'Films'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232281/creative_films_jsaevi.jpg"
      elsif subcategory.name == 'Writing'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232291/creative_writing_wja4of.jpg"
      elsif subcategory.name == 'Music'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232291/creative_music_nibbax.jpg"
      elsif subcategory.name == 'Dance'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232277/creative_dance_lkdwzh.jpg"
      elsif subcategory.name == 'Photography'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232291/creative_photography_dw9tv6.jpg"
      elsif subcategory.name == 'Miscellaneous'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232290/creative_misc_lroifk.jpg"
      end
    elsif category.name == 'Education'
      if subcategory.name == 'School'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232689/education_school_foocoh.jpg"
      elsif subcategory.name == 'Online Courses'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232682/education_onlinecourses_awnzrz.jpg"
      elsif subcategory.name == 'Private Lessons'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232689/education_privatelessons_dmxqq5.jpg"
      end
    elsif category.name == 'Gifts'
      if subcategory.name == 'Special Occasion'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232792/gifts_specialoccasion_kq8z3f.jpg"
      elsif subcategory.name == 'Surprise'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232792/gifts_surprise_yv4cb2.jpg"
      elsif subcategory.name == 'Thank You'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411232793/gifts_thankyou_s3i7l7.jpg"
      end
    elsif category.name == 'Ideas'
      if subcategory.name == 'Startups'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233077/ideas_startups_tkiw0v.jpg"
      elsif subcategory.name == 'Challenge'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233077/ideas_challenge_eiu1nl.jpg"
      elsif subcategory.name == 'Community'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233078/ideas_community_vjjuii.jpg"
      elsif subcategory.name == 'Research'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233077/ideas_research_yi3rjg.jpg"
      elsif subcategory.name == 'Bucket List'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233077/ideas_bucketlist_rdgj5e.jpg"
      end
    elsif category.name == 'Lifestyle'
      if subcategory.name == 'Fun/ Leisure'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233253/lifestyle_fun_ffwput.jpg"
      elsif subcategory.name == 'Deals/ Bargains'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233253/lifestyle_deals_dhq6lq.jpg"
      elsif subcategory.name == 'Health/ Diet'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233253/lifestyle_health_zsofbw.jpg"
      elsif subcategory.name == 'Fitness/ Exercise'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233252/lifestyle_fitness_yilrgl.jpg"
      elsif subcategory.name == 'Family/ Parenting'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233253/lifestyle_parenting_bcporc.jpg"
      elsif subcategory.name == 'Dating/ Romance'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233252/lifestyle_dating_cidnxc.jpg"
      end
    elsif category.name == 'Travel'
      if subcategory.name == 'Travel Suggestions'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233580/travel_suggestions_dkws5z.jpg"
      elsif subcategory.name == 'Vacation Planning'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233581/travel_planning_pn3pdw.jpg"
      elsif subcategory.name == 'Postcards'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233580/travel_postcard_e9bywc.jpg"
      elsif subcategory.name == 'Places to Stay'
        "http://res.cloudinary.com/dxytnnzk9/image/upload/v1411233580/travel_placetostay_borbi1.jpg"
      end
    end 
  end

	def fetch_page_posts(posts, page)
    city = request.location.city rescue ""
    country = request.location.country rescue ""
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

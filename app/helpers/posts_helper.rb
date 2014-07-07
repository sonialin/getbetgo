module PostsHelper
	def reformatted_post_datetime(time_created_at)
	  distance = Time.now - time_created_at

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
end

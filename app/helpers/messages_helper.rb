module MessagesHelper

	def messages_class(post)
		if post.read?
			html = "class='message read'"
		else
			html = "class='message'"
		end
		html.html_safe
	end

end

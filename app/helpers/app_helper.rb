module AppHelper
    def HasUserLiked
        liked = false
        user = User.where(:hash => cookies[:hash])
        post = Post.find(params[:id])
        unless user.any?
            liked = true
        end
        if Like.where(:user => user, :post => post).any?
            liked = true
        end
        return liked
    end
    def TimeToMs(time)
        time.strftime('%Q')
    end
    def SaveUser(user)
        suppress(StandardError) do
            user.save
        end
    end
    def CleanText(str)
        str.gsub "\n", "<br>"
    end

end

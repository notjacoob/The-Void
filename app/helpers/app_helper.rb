module AppHelper
    def HasUserLiked
        liked = false
        user = User.where(:hash => cookies[:hash])
        post = Post.find(params[:id])
        if !user.any?
            liked = true
        end
        if Like.where(:user => user, :post => post).any?
            liked = true
        end
        return liked
    end
    def TimeToMs(time)
        return time.strftime('%Q')
    end
    def SaveUser(user)
        suppress(StandardError) do
            user.save
        end
    end
    def CleanText(str)
        return str.gsub "\n", "<br>"
    end

end

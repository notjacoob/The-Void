module ModerationHelper
    def FirstFive(str)
        split = str.split
        news = ""
        for i in 1..split.length
            if i <= 5
                news += split[i-1] + " "
            else
                break
            end
        end
        if split.length > 5
            news += "..."
        end
        return news
    end
end
module ModerationHelper
    def FirstFive(str)
        split = str.split
        news = ""
        (1..split.length).each { |i|
            if i <= 5
                news += split[i - 1] + " "
            else
                break
            end
        }
        if split.length > 5
            news += "..."
        end
        news
    end
end
module Superbara
  class Config
    def tags
      tags_string = ENV["SUPERBARA_TAGS"]
      return [] unless tags_string

      tags = tags_string.split(",")
      if tags.any?
        tags
      else
        []
      end
    end
  end
end

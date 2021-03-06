require 'html/pipeline'

module TagHelper
  def human_time(time)
    content_tag :abbr, class: "timeago", title: time.iso8601 do
      time.to_formatted_s(:long)
    end
  end

  def short_date(time)
    return "Today" if time.today?
    time.strftime("%d %b")
  end

  def markdownify(text)
    md_pipeline.call(text)[:output].html_safe
  end

  def sanitize_whitelist
    Sanitize::Config.merge(
      Sanitize::Config::BASIC,
      elements: %w(h1 h2 h3 h4 h5 h6 a p strong em ul ol li code pre),
      attributes: {
        'a' => %w(href title class rel),
        'span' => %w(class),
        'pre' => %w(class lang),
        'code' => %w(class)
      }
    )
  end

  def md_pipeline
    @md_pipeline ||= HTML::Pipeline.new(
      [
        HTML::Pipeline::MarkdownFilter,
        HTML::Pipeline::SanitizationFilter,
        HTML::Pipeline::EmojiFilter,
        HTML::Pipeline::MentionFilter,
        HTML::Pipeline::AutolinkFilter
      ],
      gfm: true,
      whitelist: sanitize_whitelist,
      asset_root: "/images",
      base_url: "/team",
      username_pattern: UsernameValidator::USERNAME_REGEXP
    )
  end
end

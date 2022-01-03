module ApplicationHelper

  # 何時何日まえに作られた投稿かを返す
  def is_created_at(post)
    created_time = time_ago_in_words(post.create_at)
    created_time.include?("約")
    created_time.include?("未満")
    case created_time
    when 値1 then
    when 値2 then
    when 値3 then
    end
  end

  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "TechBookHub"
    if page_title.present?
      page_title + " / " + base_title
    else
      base_title
    end
  end
end

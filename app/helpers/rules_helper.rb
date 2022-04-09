module RulesHelper
  def user_rule(rule)
    case rule
    when 'admin'
      tag.span("権限ユーザー")
    when 'sample'
      tag.span("サンプルユーザー")
    when 'general'
      tag.span("一般ユーザー")
    end
  end
end

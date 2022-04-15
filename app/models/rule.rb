class Rule < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  RULE_VALUES = ["admin", "sample", "general"].freeze
  validates :rule_name, presence: true, inclusion: { in: RULE_VALUES }
end

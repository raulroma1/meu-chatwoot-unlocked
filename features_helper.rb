cat << 'EOF' > /data/coolify/custom_configs/features_helper.rb
module SuperAdmin::FeaturesHelper
  def self.all_features
    YAML.load(ERB.new(Rails.root.join('app/helpers/super_admin/features.yml').read).result).with_indifferent_access
  end
  def self.available_features
    all_features.reject { |_, attrs| attrs[:fazer_ai] }
  end
  def self.plan_details
    "You are currently on the <span class='font-semibold'>Community (Unlocked)</span> edition."
  end
  def self.fazer_ai_subscription_details
    parts = ["Status: <span class='text-green-600 font-semibold'>Active (Unlimited)</span>", "Features: <span class='font-semibold'>Kanban, Captain</span>"]
    parts << kanban_accounts_text
    parts.compact.join(' · ').html_safe
  end
  def self.subscription_status_label
    "Status: <span class='text-green-600 font-semibold'>Active</span>"
  end
  def self.kanban_accounts_text
    current_count = Account.where('feature_flags & ? != 0', Featurable.feature_flag_value('kanban')).count rescue 0
    "Kanban Accounts: <span class='font-semibold'>#{current_count}/Unlimited</span>"
  end
  def self.subscription_features_text; "Features: <span class='font-semibold'>Kanban, Captain</span>"; end
  def self.sync_warning_text; nil; end
  def self.subscription_trialing_text; nil; end
  def self.subscription_canceling_text; nil; end
  def self.accounts_with_fazer_ai_features; []; end
  def self.fazer_ai_features
    all_features.select { |_, attrs| attrs[:fazer_ai] }
  end
end
EOF

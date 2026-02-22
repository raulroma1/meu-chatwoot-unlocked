#!/bin/bash
mkdir -p /data/coolify/custom_configs

# Criar o Bypass da Licença
cat << 'EOF' > /data/coolify/custom_configs/fazer_ai_hub.rb
# frozen_string_literal: true
class FazerAiHub
  class << self
    def installation_identifier; ChatwootHub.installation_identifier; end
    def billing_url; "https://app.fazer.ai/api/billing?installation_identifier=#{installation_identifier}"; end
    def subscription_status; 'active'; end
    def kanban_account_limit; 0; end
    def feature_limit(feature_name, limit_key); 0; end
    def instance_type; 'pro'; end
    def enabled_features; ['kanban', 'captain', 'audit_logs', 'custom_roles']; end
    def features; { 'kanban' => { 'account_limit' => 0 }, 'captain' => { 'enabled' => true } }; end
    def feature_enabled?(feature_name); true; end
    def synced?; true; end
    def never_synced?; false; end
    def out_of_sync?; false; end
    def sync_error_at; nil; end
    def last_synced_at; Time.current; end
    def subscription_active?; true; end
    def subscription_past_due?; false; end
    def subscription_canceling?; false; end
    def subscription_period_end; (Time.current + 10.years).to_i; end
    def instance_config
      {
        installation_identifier: installation_identifier,
        installation_version: Chatwoot.config[:version],
        installation_host: URI.parse(ENV.fetch('FRONTEND_URL', 'http://localhost')).host,
        instance_type: 'chatwoot',
        session_id: "unlocked-session",
        feature_usage: { kanban: { account_limit: kanban_enabled_accounts_count } }
      }
    end
    def kanban_enabled_accounts_count
      Account.where('feature_flags & ? != 0', Featurable.feature_flag_value('kanban')).count
    rescue
      0
    end
    def sync_subscription; { 'status' => 'active' }; end
    def subscription_verified_recently?; true; end
    def subscription_token; "unlocked-token"; end
    def subscription_token_valid?; true; end
    def verify_subscription_token(token); { 'status' => 'active' }; end
    def last_known_subscription_status; 'active'; end
    def clear_cache!; nil; end
    private
    def cached_subscription_data
      { status: 'active', features: { 'kanban' => { 'account_limit' => 0 } } }
    end
  end
end
EOF

# Criar o Bypass da Interface
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

echo "Arquivos de destrave criados com sucesso!"

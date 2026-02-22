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

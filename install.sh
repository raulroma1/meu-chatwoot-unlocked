#!/bin/bash
mkdir -p /data/coolify/custom_configs

# Criar o Bypass da Licença
cat << 'EOF' > /data/coolify/custom_configs/fazer_ai_hub.rb
# frozen_string_literal: true
class FazerAiHub
  class << self
    def installation_identifier; ChatwootHub.installation_identifier; end
    def billing_url; "https://app.fazer.ai/api/billing"; end
    def subscription_status; 'active'; end
    def kanban_account_limit; 0; end
    def feature_limit(feature_name, limit_key); 0; end
    def instance_type; 'pro'; end
    def enabled_features; ['kanban', 'captain', 'audit_logs', 'custom_roles']; end
    def features; { 'kanban' => { 'account_limit' => 0 }, 'captain' => { 'enabled' => true } }; end
    def feature_enabled?(feature_name); true; end
    def synced?; true; end
    def subscription_active?; true; end
    def subscription_period_end; (Time.current + 10.years).to_i; end
    def sync_subscription; { 'status' => 'active' }; end
    def last_known_subscription_status; 'active'; end
    def clear_cache!; nil; end
  end
end
EOF

# Criar o Bypass da Interface
cat << 'EOF' > /data/coolify/custom_configs/features_helper.rb
module SuperAdmin::FeaturesHelper
  def self.all_features
    YAML.load(ERB.new(Rails.root.join('app/helpers/super_admin/features.yml').read).result).with_indifferent_access
  end
  def self.plan_details; "Enterprise Edition (Unlocked)"; end
  def self.fazer_ai_subscription_details; "Status: <span class='text-green-600 font-semibold'>Active</span>".html_safe; end
  def self.subscription_status_label; "Status: <span class='text-green-600 font-semibold'>Active</span>"; end
  def self.kanban_accounts_text; "Kanban: Unlimited"; end
  def self.fazer_ai_features; all_features.select { |_, attrs| attrs[:fazer_ai] }; end
end
EOF

echo "Arquivos de destrave criados com sucesso!"

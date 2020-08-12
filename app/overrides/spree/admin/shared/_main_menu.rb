Deface::Override.new(
    virtual_path: 'spree/admin/shared/_main_menu',
    name: 'Display configuration tab for vendors',
    replace: 'erb[silent]:contains("current_store")',
    text: '<% if can?(:admin, current_store) || current_spree_user.vendors.any? %>'
)
Deface::Override.new(
    virtual_path:  'spree/admin/shared/_main_menu',
    name:          'vendors_main_menu_tabs',
    insert_bottom: 'nav',
    text:       <<-HTML
                <% if current_spree_user.respond_to?(:has_spree_role?) && current_spree_user.has_spree_role?(:admin) %>
                  <ul class="nav nav-sidebar border-bottom">
                    <%= tab 'Celebrities', url: admin_vendors_path, icon: 'user' %>
                  </ul>
                <% end %>
<% if defined?(current_spree_vendor) && current_spree_vendor %>
                  <ul class="nav nav-sidebar border-bottom">
                    <%= tab 'sales_report', url: admin_sale_reports_path, icon: 'file' %>
                  </ul>
                <% end %>
<% if defined?(current_spree_vendor) && current_spree_vendor %>
                  <ul class="nav nav-sidebar border-bottom">
                    <%= tab 'block_fans', url: admin_block_fans_path, icon: 'user' %>
                  </ul>
                <% end %>
                <% if defined?(current_spree_vendor) && current_spree_vendor %>
                  <ul class="nav nav-sidebar border-bottom">
                    <%= tab 'Celebrity', url: admin_vendor_settings_path, icon: 'user' %>
                  </ul>
                <% end %>
HTML
)

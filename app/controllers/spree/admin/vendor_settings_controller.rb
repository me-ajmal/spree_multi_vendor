module Spree
  module Admin
    class VendorSettingsController < Spree::Admin::BaseController
      before_action :authorize
      before_action :load_vendor

      def update
        if vendor_params[:image] && Spree.version.to_f >= 3.6
          @vendor.create_image(attachment: vendor_params[:image])
        end
        if @vendor.update(vendor_params.except(:image))
          redirect_to admin_vendor_settings_path
        else
          render :edit
        end
      end

      def sale_reports
         @categories = Spree::Taxonomy.includes(root: :children).find_by(name: 'Categories').taxons.select{|s|s.children.empty?}
      end
      def get_order_report  
        @categories = Spree::Taxonomy.includes(root: :children).find_by(name: 'Categories').taxons.select{|s|s.children.empty?}
        @orders = Spree::Order.all  
          if params[:taxon_id].present?
            category_orders = []
            Spree::Order.all.each do |order|
             category_orders  << order if order.products.present? && order.products.select{|product| product.category.present? && product.category.id.to_s == params[:category_id] }.present?
           end
           @orders = category_orders.flatten
          end
          @orders = Spree::Order.where(id: @orders.pluck(:id)) if @orders.present?
          @total_amount = 0
          @complete_amount =0
          @pending_amount = 0
          @pending_order = 0
          @complete_order = 0
          @orders.each do |order|
            # @totals[order.currency] = { item_total: ::Money.new(0, order.currency), adjustment_total: ::Money.new(0, order.currency), sales_total: ::Money.new(0, order.currency),sales_complete: ::Money.new(0, order.currency),sales_pending: ::Money.new(0, order.currency)} unless @totals[order.currency]
            # @totals[order.currency][:item_total] += order.display_item_total.money
            # @totals[order.currency][:adjustment_total] += order.display_adjustment_total.money
            @total_amount += order.amount.to_i
            @complete_amount += order.amount.to_i if order.state == "complete"
            @pending_amount += order.amount.to_i if order.state == "pending"
            @pending_order += 1 if order.state == "pending"
            @complete_order += 1 if order.state == "complete"
          end
      end

      def block_fans
        # all fans
        # fans = Spree::User.includes(:vendor_users).where(spree_vendor_users: { user_id: nil })
        @fans = []
        vendor_products_ids = spree_current_user.vendors.first.products.pluck(:id)
        Spree::Order.all.each do |order|
          if (order.products.pluck(:id) & vendor_products_ids).present?
            @fans << order.user if !(order.user.has_spree_role? :admin)
          end
        end
      end

      def change_status
        if params[:fan_id].present?
          current_status = Spree::FanStatus.where(fan_id: params[:fan_id]).where(vendor_id: spree_current_user.id).first

          if current_status.present?
            current_status.status = current_status.status == 'block' ? 'unblock' : 'block'
            current_status.save!
          else
            Spree::FanStatus.create(fan_id: params[:fan_id], vendor_id: spree_current_user.id, status: 'block')
          end
        end
      end

      private

      def authorize
        authorize! :manage, :vendor_settings
      end

      def load_vendor
        @vendor = current_spree_vendor
        raise ActiveRecord::RecordNotFound unless @vendor
      end

      def vendor_params
        params.require(:vendor).permit(Spree::PermittedAttributes.vendor_attributes)
      end
    end
  end
end
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
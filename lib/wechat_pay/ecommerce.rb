require 'wechat_pay/helper'

module WechatPay
  module Ecommerce
    include WechatPayHelper

    class<<self
      # 二级商户进件
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_1.shtml
      def applyment(payload)
        url = '/v3/ecommerce/applyments/'
        method = 'POST'

        payload_json = payload.to_json

        make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json,
          extra_headers: {
            'Wechatpay-Serial' => WechatPay.platform_serial_no
          }
        )
      end

      # 通过商户的申请单或微信的申请单号查询
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_2.shtml
      QUERY_APPLYMENTS_FIELDS = %i[applyment_id out_request_no].freeze
      def query_applyment(params)
        if params[:applyment_id]
          applyment_id = params.delete(:applyment_id)
          url = "/v3/ecommerce/applyments/#{applyment_id}"
        else
          out_request_no = params.delete(:out_request_no)
          url = "/v3/ecommerce/applyments/out-request-no/#{out_request_no}"
        end
        method = 'GET'

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 证书获取
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter7_1_3.shtml
      def get_certificates
        url = '/v3/certificates'
        method = 'GET'

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 查询结算账户
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter11_1_4.shtml
      INVOKE_QUERY_SETTLEMENT_FIELDS = [:sub_mchid].freeze
      def query_settlement(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/apply4sub/sub_merchants/#{sub_mchid}/settlement"
        method = 'GET'

        make_request(
          method: method,
          path: url,
          extra_headers: {
            'Content-Type' => 'application/x-www-form-urlencoded'
          }
        )
      end

      # 修改结算账号, TODO 添加字段检测
      INVOKE_MODIFY_SETTLEMENT_FIELDS = %i[sub_mchid account_type account_bank bank_address_code account_number].freeze
      def modify_settlement(params)
        sub_mchid = params.delete(:sub_mchid)
        url = "/v3/apply4sub/sub_merchants/#{sub_mchid}/modify-settlement"
        method = 'POST'

        payload_json = params.to_json

        make_request(
          method: method,
          path: url,
          for_sign: payload_json,
          payload: payload_json,
          extra_headers: {
            'Wechatpay-Serial' => WechatPay.platform_serial_no
          }
        )
      end

      # 视频上传
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_2.shtml
      def media_video_upload(video)
        url = '/v3/merchant/media/video_upload'
        method = 'POST'
        meta = {
          filename: video.to_path,
          sha256: Digest::SHA256.hexdigest(video.read)
        }

        video.rewind
        payload = {
          meta: meta.to_json,
          file: video
        }

        make_request(
          method: method,
          path: url,
          for_sign: meta.to_json,
          payload: payload,
          extra_headers: {
            'Content-Type' => nil
          }
        )
      end

      # 图片上传
      # Doc: https://pay.weixin.qq.com/wiki/doc/apiv3_partner/apis/chapter2_1_1.shtml
      def media_upload(image)
        url = '/v3/merchant/media/upload'
        method = 'POST'
        meta = {
          filename: image.to_path,
          sha256: Digest::SHA256.hexdigest(image.read)
        }

        image.rewind
        payload = {
          meta: meta.to_json,
          file: image
        }

        make_request(
          method: method,
          path: url,
          for_sign: meta.to_json,
          payload: payload,
          extra_headers: {
            'Content-Type' => nil # Pass nil to remove the Content-Type
          }
        )
      end
    end
  end
end

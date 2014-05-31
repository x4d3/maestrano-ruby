require File.expand_path('../../../test_helper', __FILE__)

module Maestrano
  module Account
    class BillTest < Test::Unit::TestCase
      include APITestHelper
      
      should "should be listable" do
        @api_mock.expects(:get).once.returns(test_response(test_account_bill_array))
        c = Maestrano::Account::Bill.all
        assert c.data.kind_of? Array
        c.each do |bill|
          assert bill.kind_of?(Maestrano::Account::Bill)
        end
      end

      should "should be cancellable" do
        @api_mock.expects(:delete).once.returns(test_response(test_account_bill))
        c = Maestrano::Account::Bill.construct_from(test_account_bill[:data])
        c.cancel
      end

      should "should not be updateable" do
        assert_raises NoMethodError do
          @api_mock.stubs(:put).returns(test_response(test_account_bill))
          c = Maestrano::Account::Bill.construct_from(test_account_bill[:data])
          c.save
        end
      end


      should "should successfully create a remote bill when passed correct parameters" do
        @api_mock.expects(:post).with do |url, api_token, params|
          url == "#{Maestrano.param('api_host')}#{Maestrano.param('api_base')}account/bills" && api_token.nil? && 
          CGI.parse(params) == {"group_id"=>["cld-1"], "price_cents"=>["23000"], "currency"=>["AUD"], "description"=>["Some bill"]}
        end.once.returns(test_response(test_account_bill))

        bill = Maestrano::Account::Bill.create({
          group_id: 'cld-1',
          price_cents: 23000,
          currency: 'AUD',
          description: 'Some bill'
        })
        assert bill.id
      end
    end
  end
end
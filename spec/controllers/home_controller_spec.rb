require 'spec_helper'

describe HomeController do

  describe "GET 'home/index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end

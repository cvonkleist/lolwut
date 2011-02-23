require "test_helper"

describe 'css' do
  it "should render the default stylesheet" do
    get "/css/main.css"
    last_response.content_type.should == "text/css;charset=UTF-8"
  end
end

require "stories_helper"

describe 'site' do
  it "should show me the homepage so I know Monk is correctly installed" do
    visit "/"

    body.should contain('Hello, world!')
  end
end

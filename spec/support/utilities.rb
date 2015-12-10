# helper's methods static_pages_spec.rb
def full_title(page_title)
  base_title = "Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def have_rigth_links(link, title)
  click_link link
  expect(page).to have_title(full_title(title))
end

def have_heading_title(heading, options = {title: heading})
  it { should have_selector('h1', text: heading) }
  it { should have_title(options[:title]) }
end

require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_array = []
    student_card = doc.css("div.roster-cards-container div.student-card")
    student_card.each do |card|
      student_hash = {
      :name => card.css("div.card-text-container h4.student-name").text,
      :location => card.css("div.card-text-container p.student-location").text,
      :profile_url => card.css("a").attr("href").value
    }
      student_array << student_hash
    end
    student_array 
    
  end
  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student_info = {
      :profile_quote => doc.css("div.main-wrapper div.vitals-container div.vitals-text-container div.profile-quote").text,
      :bio => doc.css("div.main-wrapper div.details-container div.bio-block div.bio-content div.description-holder p").text
    }
    scraped_data = doc.css("div.main-wrapper div.vitals-container div.social-icon-container a")
    scraped_data.each do |l|
        target = l.attr("href")
        if target.include?("twitter")
          student_info[:twitter] = target
        elsif target.include?("linkedin")
          student_info[:linkedin] = target
        elsif target.include?("github")
          student_info[:github] = target
        else
          student_info[:blog] = target
        end
    end
    student_info
  end
end

  


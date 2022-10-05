class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end

  #self.with_ratings method is based off office hours discussion and conceptual level discussions with classmates
  def self.with_ratings(ratings_list, sort_by)
    if ratings_list.nil?
      all.order sort_by
    else
      where(rating: ratings_list.map(&:upcase)).order sort_by
    end
  end
end

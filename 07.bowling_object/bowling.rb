# frozen_string_literal: true

require 'test/unit'

class Game
  attr_reader :marks

  def initialize(marks)
    @marks = marks.split(',')
  end

  def split_frames
    frames = trim_shots.each_slice(2).map { |arr| arr }
    if frames.size == 11
      frame_last = frames[9] + frames[10]
      frames.slice!(0..8) + [frame_last]
    else
      frames
    end
  end

  def generate_frames
    split_frames.map { |frame| Frame.new(*frame) }
  end

  def score
    score = 0
    generate_frames.each_with_index do |frame, i|
      case i
      when 0..8
        if generate_frames[i].first_mark.mark == 10
          score += frame.score + generate_frames[i + 1].first_mark.mark + generate_frames[i + 1].second_mark.mark
          score += generate_frames[i + 2].first_mark.mark if generate_frames[i + 1].first_mark.mark == 10 && i != 8
        elsif generate_frames[i].score == 10
          score += frame.score + generate_frames[i + 1].first_mark.mark
        else
          score += frame.score
        end
      else
        score += frame.score
      end
    end
    score
  end

  private

  def trim_shots
    shots = []
    shots_count = 0
    @marks.each do |mark|
      shots_count += 1
      if mark == 'X'
        shots << 10
        if shots_count == 1
          shots << 0
          shots_count = 0
        end
      else
        shots << mark.to_i
      end
      shots_count = 0 if shots_count == 2
    end
    last_frame = shots.slice(18..-1)
    shots.slice!(0..17) + remove_zero(last_frame)
  end

  def remove_zero(last_frame)
    if last_frame.length == 6
      remove_zero_6length(last_frame)
    elsif last_frame.length == 4
      remove_zero_4length(last_frame)
    else
      last_frame
    end
  end

  def remove_zero_4length(last_frame)
    last_frame[1].zero? ? last_frame.delete_at(1) : last_frame.delete_at(2)
    last_frame
  end

  def remove_zero_6length(last_frame)
    last_frame.delete(0)
    last_frame
  end
end

class Frame
  attr_reader :first_mark, :second_mark, :third_mark

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_mark = Shot.new(first_mark)
    @second_mark = Shot.new(second_mark)
    @third_mark = Shot.new(third_mark)
  end

  def score
    @first_mark.score + @second_mark.score + @third_mark.score
  end
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    @mark.to_i
  end
end

class TestBowling < Test::Unit::TestCase
  def test_boling_score
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').score
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').score
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').score
    assert_equal 134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').score
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').score
  end
end

game = Game.new(ARGV[0])
p game.score

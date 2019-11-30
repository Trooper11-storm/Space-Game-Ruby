require 'gosu'

module ZOrder
	BACKGROUND, STARS, PLAYER, UI = *0..3
end



class Tutorial < Gosu::Window
	def initialize
		super 640, 480 # :fullscreen => true
		self.caption ="Space Game"
		#sets the background image
		@background_image = Gosu::Image.new("space.png", :tileable => true)
		
		@player = Player.new
		#pass into the function warp in the class player
		@player.warp(320,240)

		@star_anim = Gosu::Image.load_tiles("star.png",25,25)
		@stars = Array.new


	end

	def update
		if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
			@player.turn_left
		end
		if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
			@player.turn_right
		end
		if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
			@player.accelerate
		end
		@player.move
		@player.collect_stars(@stars)

		if rand(100) < 4 and @stars.size < 25
			@stars.push(Star.new(@star_anim))
		end

	end

	def draw
		@player.draw
		@background_image.draw(0, 0, ZOrder::BACKGROUND)
		@stars.each { |star| star.draw }
	end

	def button_down(id)
    	if id == Gosu::KB_ESCAPE
      		close
    	else
      		super
    	end
  	end
end



#Our Main Player Class
class Player
	def initialize
		@image = Gosu::Image.new("starfighter.bmp")
		#setting x,y,vel_y and angle to 0
		@x = @y = @vel_x = @vel_y = @angle = 0.0
		@score = 0
	end

	def warp(x, y)
		#passing the variable into instance variables
		@x, @y = x, y
	end

	def turn_left
		@angle -= 4.5
	end

	def turn_right
		@angle +=4.5
	end

	def accelerate
		#offset = cosine
		@vel_x += Gosu.offset_x(@angle, 0.5)
		@vel_y += Gosu.offset_x(@angle, 0.5)
	end

	def move
		@x += @vel_x
		@y += @vel_y
		@x %= 640
		@y %= 480

		@vel_x *= 0.95
		@vel_y *= 0.95
	end

	def draw
		@image.draw_rot(@x, @y, 1, @angle)
	end

	def score
		@score
	end

	def collect_stars(stars)
		#not stars.reject
		stars.reject! { |star| Gosu.distance(@x, @y, star.x, star.y) < 35 }
	end


end



#Add stars

class Star
	def initialize(animation)
		@animation = animation
		@color = Gosu::Color::BLACK.dup
		#creates random colours
		@color.red = rand(256 - 40) + 40
		@color.green = rand(256 - 40) + 40
		@color.blue = rand(256 - 40) + 40
		@x = rand * 640
		@y = rand * 480
	end

	def draw
		img = @animation[Gosu.milliseconds / 100 % @animation.size]
		img.draw(@x - img.width / 2.0, @y - img.height / 2.0, ZOrder::STARS, 1, 1, @color, :add)
	end
end


Tutorial.new.show

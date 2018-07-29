class ToyRobot
  ORIENTATION = %w(SOUTH WEST NORTH EAST)
  ORIENTATION_OPERATOR = %i[- - + +]
  X_MAX_BOUNDARY = 4
  Y_MAX_BOUNDARY = 4
  MIN_BOUNDARY = 0
  ERROR_MSG = "PLACE the robot on the Board within the range of 0-4 for the x and y axis"

  class << self
    def play(commands)
      format_commands(commands)

      raise ERROR_MSG unless valid_commands?

      game_start = new
      game_start.place(*@commands[1])
      @commands[2..-2].each {|cmd| game_start.send(cmd.downcase.to_sym)}
      game_start.report
    end

    private

    def format_commands(commands)
      # @commands                    = commands.split
      # place_command                = @commands.find_index('PLACE') || 0
      # @commands[place_command + 1] = @commands[place_command + 1].split(',')
      # @commands                    = @commands[place_command..-1]

      @commands = commands.scan(/PLACE.+/).first&.split

      raise ERROR_MSG unless @commands

      @commands[1] = @commands[1].split(',')
    end

    def valid_commands?
      @commands[1][0].to_i <= X_MAX_BOUNDARY &&
          @commands[1][1].to_i <= Y_MAX_BOUNDARY &&
          @commands[1][0].to_i >= MIN_BOUNDARY &&
          @commands[1][1].to_i >= MIN_BOUNDARY
    end
  end

  def place(x, y, direction)
    @x = x.to_i
    @y = y.to_i
    send(direction.downcase.to_sym)
  end

  def report
    "#{@x},#{@y},#{ORIENTATION[@orientation]}"
  end

  private

  attr_accessor :x, :y, :orientation

  def move
    move_vertically || move_horizontally
  end

  def left
    @orientation = @orientation > 0 ? @orientation - 1 : 3
  end

  def right
    @orientation = @orientation < 3 ? @orientation + 1 : 0
  end

  ORIENTATION.each_with_index do |method, i|
    define_method(method.downcase) do
      @orientation = i
    end
  end

  def move_vertically?
    ORIENTATION[@orientation] == "SOUTH" &&
        @y > MIN_BOUNDARY ||
        ORIENTATION[@orientation] == "NORTH" &&
            @y < Y_MAX_BOUNDARY
  end

  def move_horizontally?
    ORIENTATION[@orientation] == "WEST" &&
        @x <= X_MAX_BOUNDARY &&
        @x > MIN_BOUNDARY ||
        ORIENTATION[@orientation] == "EAST" &&
            @x >= MIN_BOUNDARY &&
            @x < X_MAX_BOUNDARY
  end

  def move_vertically
    @y = @y.send(ORIENTATION_OPERATOR[@orientation], 1) if move_vertically?
  end

  def move_horizontally
    @x = @x.send(ORIENTATION_OPERATOR[@orientation], 1) if move_horizontally?
  end
end
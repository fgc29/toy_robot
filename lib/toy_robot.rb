ORIENTATION = %w(SOUTH WEST NORTH EAST)
ORIENTATION_OPERATOR = %i[- - + +]

class ToyRobot
  def self.play(commands)
    return p "PLACE the robot on Board" unless commands.include? 'PLACE'

    formatted_commands    = commands.split
    formatted_commands[1] = formatted_commands[1].split(',')
    game_start            = new()

    game_start.place(*formatted_commands[1])

    formatted_commands[2..-1].each { |cmd| game_start.send(cmd.downcase.to_sym) }
  end

  def place(x, y, direction)
    @x = x.to_i
    @y = y.to_i
    send(direction.downcase.to_sym)
  end

  private

  attr_accessor :x, :y, :orientation

  def orientation(face)
    @orientation = face
  end

  def move
    move_vertically? || move_horizontally?
  end

  def move_vertically?
    move_vertically if ORIENTATION[@orientation] == "SOUTH" && @y > 0 || ORIENTATION[@orientation] == "NORTH" && @y < 4
  end

  def move_horizontally?
    move_horizontally if ORIENTATION[@orientation] == "WEST" && @x < 4 || ORIENTATION[@orientation] == "EAST" && @x > 0
  end

  def move_vertically
    @y = @y.send(ORIENTATION_OPERATOR[@orientation], 1)
  end

  def move_horizontally
    @x = @x.send(ORIENTATION_OPERATOR[@orientation], 1)
  end

  def left
    if @orientation > 0
      @orientation -= 1
    else
      @orientation = 3
    end
  end

  def right
    if @orientation < 3
      @orientation += 1
    else
      @orientation = 0
    end
  end

  def south
    @orientation = 0
  end

  def west
    @orientation = 1
  end

  def north
    @orientation = 2
  end

  def east
    @orientation = 3
  end

  def report
    p @x, @y, ORIENTATION[@orientation]
  end
end

ToyRobot.play('PLACE 0,0,NORTH MOVE REPORT')
ToyRobot.play('PLACE 0,0,NORTH LEFT REPORT')
ToyRobot.play('PLACE 1,2,EAST MOVE MOVE LEFT MOVE REPORT')
ToyRobot.play('1,2,EAST MOVE MOVE LEFT MOVE REPORT')
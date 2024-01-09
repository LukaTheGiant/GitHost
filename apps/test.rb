class TestApp
    attr_writer :running

    def initialize(opt={})
        puts "Mounted"
        @running = false
    end

    def run(opt={})
        @running = true
        trap "INT" do
            stop()
        end
        while @running
            update()
        end
    end

    def update()
        puts 'Enter "quit" to quit'
        a = gets.chomp
        @running=false if a == 'quit'
    end


    def stop()
        puts "app done"
        @running = false
    end
end
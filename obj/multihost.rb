require 'drb/drb'

module LukaNet
    class MultiHost
        def initialize(opt={})
            @apps = {}
        end

        def mount(name, c, opt={})
            opt[:name]=name
            @apps[name] = MountedProcess.new(self,c,opt)
        end
        
        def run(name, opt = {})
            if @apps[name]
                @apps[name].run(opt)
            end
        end

        def anyRunning?()
            @apps.keys.length>0
        end

        def prune()
            @apps.each do |k,v|
                @apps.delete(k) if !v.running?
            end
        end

        class MountedProcess
            def initialize(m,c,opt={})
                @man = m
                @obj = c.new
                @pid = nil
                @running = false
            end

            def run(opt = {})
                @running = true

                @pid = fork {
                    @obj.run(opt)
                }  
            end

            def running?()
                pid, status = Process.waitpid2(@pid, Process::WNOHANG)

                if pid.nil?
                    # Child process is still running
                    return true
                else
                    # Child process has finished
                    @running = false
                    stop()
                    return false
                end
            end

            def stop()
                if @running
                    @running = false
                    Process.kill("INT",@pid)
                    @pid = nil
                    @obj = nil
                else
                    @pid = nil if @pid
                    @obj = nil if @obj
                end
            end
        end
    end
end

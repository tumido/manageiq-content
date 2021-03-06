module ManageIQ
  module Automate
    module Transformation
      module Infrastructure
        module VM
          module Common
            class PowerOn
              def initialize(handle = $evm)
                @handle = handle
              end

              def main
                if @handle.root['service_template_transformation_plan_task'].blank?
                  task = @handle.vmdb(:service_template_transformation_plan_task).find_by(:id => @handle.root['service_template_transformation_plan_task_id'])
                  vm = task.source if task.present?
                else
                  task = @handle.root['service_template_transformation_plan_task']
                  vm = @handle.vmdb(:vm).find_by(:id => task.get_option(:destination_vm_id)) if task.present?
                end
                return if vm.blank?
                vm.start if task.get_option(:source_vm_power_state) == 'on'
              rescue => e
                @handle.set_state_var(:ae_state_progress, 'message' => e.message)
                raise
              end
            end
          end
        end
      end
    end
  end
end

ManageIQ::Automate::Transformation::Infrastructure::VM::Common::PowerOn.new.main

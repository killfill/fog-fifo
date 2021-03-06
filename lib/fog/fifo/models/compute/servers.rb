require 'fog/core/collection'
require 'fog/fifo/models/compute/server'

module Fog
  module Compute

    class Fifo
      class Servers < Fog::Collection
        model Fog::Compute::Fifo::Server

        def all
          service.list_vms().body.map{|id| get(id) }
        end

        def create(params = {})
          resp = service.create_vm(params)

	  #This will retrn a 303 with location = new vm url, so just get it.
	  get(resp.headers['location'].split('/').last)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server
        end

        def get(machine_id)
          data = service.get_vm(machine_id).body
          new(data)
        end

      end
    end # Fifo

  end # Compute
end # Fog

# spec/nodes/node_spec.rb
require 'rails_helper'
require_relative '../../app/nodes/node'

RSpec.describe Node, type: :model do
  let(:node1) { Node.new(1) } #OK
  let(:node2) { Node.new(2) } #OK
  let(:node3) { Node.new(3) } #OK

  before do
    node1.add_neighbor(node2)
    node1.add_neighbor(node3)
    node2.add_neighbor(node1)
    node2.add_neighbor(node3)
    node3.add_neighbor(node1)
    node3.add_neighbor(node2)
  end

  #Test to ensure that each node has the right neighbors
  it 'should have the correct neighbors for node1' do #OK
    expect(node1.neighbors).to include(node2)
    expect(node1.neighbors).to include(node3)
    expect(node1.neighbors.size).to eq(2)
  end

  it 'should have the correct neighbors for node2' do #OK
    expect(node2.neighbors).to include(node1)
    expect(node2.neighbors).to include(node3)
    expect(node2.neighbors.size).to eq(2)
  end

  it 'should have the correct neighbors for node3' do #OK
    expect(node3.neighbors).to include(node1)
    expect(node3.neighbors).to include(node2)
    expect(node3.neighbors.size).to eq(2)
  end

  #Test to check 
  [ [1, :node1], [2, :node2] ].each do |state, node_sym|
    it "logs proposed state #{state} for the node" do
      node = send(node_sym)
      node.propose_state(state)
      expect(node.retrieve_log).to include("Proposed new state: #{state}")
    end
  end

  it 'handles network partition' do
    node3.simulate_partition([node1])
    node2.propose_state(3)
    expect(node3.retrieve_log).to include('Simulated network partition with nodes: [1]')
  end

  it 'handles node failures gracefully' do
    node2.simulate_failure
    node1.propose_state(2)
    expect(node2.retrieve_log).to include('Node 2 has failed')
  end

  it 'reaches consensus with majority cons' do
    node1.propose_state(5)
    expect(node1.retrieve_log).to include('Consensus reached on state 5')
    it 'handles network partition' do
      node3.simulate_partition([node1])
      node2.propose_state(3)
      expect(node3.retrieve_log).to include('Simulated network partition with nodes: [1]')
    end
  
    it 'handles node failures gracefully' do
      node2.simulate_failure
      node1.propose_state(2)
      expect(node2.retrieve_log).to include('Node 2 has failed')
    end
  
    it 'reaches consensus with majority cons' do
      node1.propose_state(5)
      node2.cons_for_state(5, node1)
      node3.cons_for_state(5, node1)
      expect(node1.retrieve_log).to include('Consensus reached on state 5')
    end
  end
end
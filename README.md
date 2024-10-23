# Distributed System Simulation
# Distributed System Simulation

## Description

This project simulates a distributed system where multiple nodes communicate with each other to achieve consensus on a shared state. The simulation includes the implementation of a consensus algorithm (such as Paxos or Raft) and gracefully handles network partitions and node failures.

## Requirements

- Ruby 3.1 or higher
- Bundler
- Necessary dependencies

## Installation

1. **Clone the repository**:
   git clone https://github.com/fcasallas21/DistributedSystemSimulation.git
   cd DistributedSystemSimulation
2. **Intall Gems**
    bundle install
3. **Run test**
    bundle exec rspec ##all test
    bundle exec rspec ./spec/nodes/node_spec.rb:77 ##Specific test
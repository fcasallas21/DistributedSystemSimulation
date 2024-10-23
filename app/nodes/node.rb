class Node
  #Simulacion del sistema donde varios nodos se comunican para alcanzar un consenso sobre un estado compartido
  #1. Nodos: Indentificadores, enviar y recibir mensajes, registro de mensajes y transiciones de estados
  #2. Algoritmo de consenso?, encapsular dentro de la clase node
  #3. gestion Particiones y fallos
  #4. Registro de mensajes 
  attr_reader :id, :neighbors, :log, :state

  def initialize(id)
    @id = id #Node identfier
    @message_log = [] #log for sent/received messages
    @state = nil #transaction state to keep node state
    @neighbors = [] #relation/communication with other nodes
    @counter = 0 #counter to measure the new status proposal
    @partitioned_nodes = [] #Nodes that cannot communicate with origin node
    @active = true #initialize that node is active or not
    @consensus_votes = Hash.new(0)
  end

  def add_neighbor(node) #to check new neighbor, TEST OK
    @neighbors << node unless @neighbors.include?(node)
  end

  def send_message(message, target_node)
    return unless @active
    if !@partitioned_nodes.include?(target_node)
      target_node.receive_message(message)
      @message_log << "Sent message to Node #{target_node.id}: #{message}"
    end
  end

  def receive_message(message)
    return unless @active
    @message_log << "Received message: #{message}"
  end

  def propose_state(new_status)
    return unless @active
    @state = new_status
    @message_log << "Proposed new state: #{new_status}"
    request_consensus
  end

  def request_consensus
    @neighbors.each do |neighbor|
      send_message("Requesting vote for state #{@state}", neighbor)
      neighbor.cons_for_state(@state, self)
    end
  end

  def cons_for_state(proposed_state, requester) ###Request consensus
    return unless @active
    if @state.nil? || proposed_state > @state
      @consensus_votes[proposed_state] += 1
      @message_log << "Node #{@id} voted for state #{proposed_state}. Total votes: #{@consensus_votes[proposed_state]}"
      check_consensus(requester, proposed_state)
    end
  end

  def check_consensus(requester, proposed_state)
    total_votes = @consensus_votes[proposed_state] || 0
    @message_log << "Checking consensus for state #{proposed_state}. Total votes: #{total_votes}, Neighbors: #{@neighbors.size}"
    if total_votes > (@neighbors.size + 1).to_f / 2
      @state = proposed_state
      @message_log << "Consensus reached on state #{@state}"
    end
  end

  def simulate_partition(partitioned_nodes)
    @partitioned_nodes = partitioned_nodes
    @message_log << "Simulated network partition with nodes: #{partitioned_nodes.map(&:id)}"
  end

  def simulate_failure
    @active = false
    @message_log << "Node #{@id} has failed"
  end

  def retrieve_log
    #binding.pry
    @message_log.join("\n")
  end
end
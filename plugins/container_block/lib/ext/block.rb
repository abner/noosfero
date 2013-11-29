require_dependency 'block'

class Block
  
  def owner_with_container_block_plugin
    owner = owner_without_container_block_plugin
    owner.kind_of?(ContainerBlock) ? owner.owner : owner
  end

  alias_method_chain :owner, :container_block_plugin

  after_save :touch_parent_container_block

  def touch_parent_container_block
    owner = owner_without_container_block_plugin
    if owner.kind_of?(ContainerBlock)
      owner.touch
    end
  end

end

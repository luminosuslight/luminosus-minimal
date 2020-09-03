#include "AnsibleProjectBlock.h"

#include "core/manager/BlockList.h"


bool AnsibleProjectBlock::s_registered = BlockList::getInstance().addBlock(AnsibleProjectBlock::info());


AnsibleProjectBlock::AnsibleProjectBlock(CoreController* controller, QString uid)
    : BlockBase(controller, uid)
{

}

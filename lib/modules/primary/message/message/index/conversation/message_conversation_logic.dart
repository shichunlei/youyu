import 'package:youyu/controllers/base/base_controller.dart';
import 'package:youyu/controllers/conversation_controller.dart';

class MessageConversationLogic extends AppBaseController
    with ConversationRefreshListener {
  @override
  void onInit() {
    super.onInit();
    setIsLoading = true;
    ConversationController.to.addObserver(this);
    ConversationController.to.fetchList();
  }

  @override
  void pullRefresh() {
    super.pullRefresh();
    ConversationController.to.fetchList();
  }

  @override
  void onDataRefresh(bool isRefreshCompleted) {
    if (isRefreshCompleted) {
      refreshController.refreshCompleted();
    }
    setSuccessType();
  }

  @override
  void onClose() {
    super.onClose();
    ConversationController.to.removeObserver(this);
  }
}

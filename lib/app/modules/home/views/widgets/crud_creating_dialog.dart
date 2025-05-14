part of '../home_view.dart';

/// ไดอะล็อกสร้างรายการ CRUD
class CrudCreatingDialog extends StatefulWidget {
  const CrudCreatingDialog({super.key});

  @override
  State<StatefulWidget> createState() => CrudCreatingDialogState();
}

/// [State] ของ [CrudCreatingDialog]
class CrudCreatingDialogState extends State<CrudCreatingDialog> {
  late final TextEditingController textController;
  late final FocusNode focusNode;
  bool canPop = true;
  String errorMessage = '';

  HomeController get controller => Get.find<HomeController>();

  @override
  void initState() {
    textController = TextEditingController()..addListener(_onTextBoxChanged);
    focusNode = FocusNode();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (focusNode.context?.mounted == true) focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: AlertDialog(
        title: const Text('Create'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: textController, focusNode: focusNode, enabled: canPop),
            Text(errorMessage, maxLines: 1, style: const TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: canPop ? () => Get.until((route) => route.isFirst) : null,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: canPop ? () => _onCreateConfirmButtonPressed() : null,
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _onCreateConfirmButtonPressed() async {
    if (mounted) {
      setState(() {
        canPop = false;
      });
    }

    try {
      final created = await controller.createItem(textController.text);
      if (created.success && mounted) {
        Get.until((route) => route.isFirst);
      } else if (mounted) {
        setState(() {
          errorMessage = 'Error, try again';
          canPop = true;
        });
      }
    } on CrudSubmissionErrorResponseException catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.message;
          canPop = true;
        });
      }
    }
  }

  void _onTextBoxChanged() {
    if (errorMessage.isNotEmpty && mounted) {
      setState(() {
        errorMessage = '';
      });
    }
  }
}

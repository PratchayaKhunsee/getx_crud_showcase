part of '../home_view.dart';

/// ไดอะล็อกแก้ไขรายการ CRUD
class CrudUpdatingDialog extends StatefulWidget {
  final int index;
  final void Function()? onUpdate;
  const CrudUpdatingDialog({super.key, required this.index, this.onUpdate});

  @override
  State<StatefulWidget> createState() => CrudUpdatingDialogState();
}

/// [State] ของ [CrudUpdatingDialog]
class CrudUpdatingDialogState extends State<CrudUpdatingDialog> {
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
      if (mounted) {
        final value = controller.readItem(widget.index).data.toString();
        textController.value = TextEditingValue(text: value);
      }
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
        title: const Text('Edit'),
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
            onPressed: canPop ? () => _onUpdateConfirmButtonPressed() : null,
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _onUpdateConfirmButtonPressed() async {
    if (mounted) {
      setState(() {
        canPop = false;
      });
    }

    try {
      final updated = await controller.updateItem(widget.index, textController.text);
      if (updated.success) {
        widget.onUpdate?.call();
        if (mounted) Get.until((route) => route.isFirst);
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

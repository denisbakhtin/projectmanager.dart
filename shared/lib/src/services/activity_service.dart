import 'dart:async';

import '../models/models.dart';
import 'service_controller.dart';
import '../store.dart';
import '../http.dart';

class ActivityService extends ServiceController<Activity> {
  ActivityService(this.store): super(store);

  final Store store;
  Activity _activity;
  Timer _timer;
  Function onStopCallback;
  Function onFixateCallback;

  Activity get activity => _activity;

  Future<Activity> run(Task task, {Function onStop, Function onFixate}) async {
    //stop previous task
    if (_activity != null)
      stop();

    _activity = Activity()
      ..task = task
      ..lastRunAt = DateTime.now().toUtc();

    var req = new Request.post('/tasks/${task.id}/activities', _activity.asMap());
    var response = await req.executeUserRequest(store);

    if (response.error != null) {
      addError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: {
        _activity = Activity.fromMap(response.body);
        add(_activity);
        //start periodic timer
        _timer = Timer.periodic(Duration(minutes: 1), _timerCallback);
        onStopCallback = onStop;
        onFixateCallback = onFixate;
        return _activity;
      } break;

      default: addError(new APIError(response.body["error"]));
    }

    return null;
  }

  Future<void> stop() async {
    try {
      await _fixate();
    } catch(e) {
      addError(e);
    } finally {
      _activity = null;
      _timer.cancel();
      add(null);
      if (onStopCallback != null) onStopCallback();
    }
  }

  Future<void> _fixate() async {
    var req = new Request.put('/tasks/${_activity.task.id}/activities/${_activity.id}', _activity.asMap());
    var response = await req.executeUserRequest(store);

    if (response.error != null) {
      addError(response.error);
      return null;
    }

    switch (response.statusCode) {
      case 200: {
        _activity = Activity.fromMap(response.body);
        add(_activity);
        if (onFixateCallback != null) onFixateCallback();
        return _activity;
      } break;

      default: addError(new APIError(response.body["error"]));
    }
  }

  Future<void> _timerCallback(Timer timer) async {
    try {
      await _fixate();
    } catch(e) {
      addError(e);
    }
  }

}
export 'authorization_token.dart';
export 'task.dart';
export 'activity.dart';
export 'comment.dart';
export 'task_duration.dart';
export 'user.dart';
export 'project.dart';
export 'attachment.dart';
export 'session.dart';
export 'plan.dart';
export 'plan_date.dart';
export 'category.dart';

//keep it in sync with server model's priorities!!!
enum Priority {
  DoFirst, DoNext, DoLater, DoLast
}

//keep it in sync with server model's enum!!!
enum PlanType {
  category, project, task
}

//keep it in sync with server model's enum!!!
enum DateType {
  //recurring dates
  today, weekday, dayofmonth, dayofquarter, dayofyear,
  //fixed dates
  fixeddate
}

//task activity threshold in seconds, if task is active for > {minutes} + activityThreshold
//then set spent = {minutes} + 1
const activityThreshold = 15;

T enumFromString<T>(Iterable<T> values, String value) {
  return values.firstWhere((type) => type.toString().split(".").last == value,
      orElse: () => null);
}

String enumToString<T>(T value) {
  return value.toString().split(".").last;
}
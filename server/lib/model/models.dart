export 'task.dart';
export 'comment.dart';
export 'user.dart';
export 'activity.dart';
export 'project.dart';
export 'attachment.dart';
export 'session.dart';
export 'plan.dart';
export 'plan_date.dart';
export 'category.dart';

//keep it in sync with shared model's enum!!!
enum Priority {
  DoFirst, DoNext, DoLater, DoLast
}

//keep it in sync with shared model's enum!!!
enum PlanType {
  category, project, task
}

//keep it in sync with shared model's enum!!!
enum DateType {
  //recurring dates
  today, weekday, dayofmonth, dayofquarter, dayofyear,
  //fixed dates
  fixeddate
}


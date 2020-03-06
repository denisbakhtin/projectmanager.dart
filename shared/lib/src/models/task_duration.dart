class TaskDuration extends Duration {
  const TaskDuration(
      { int hours = 0,
        int minutes = 0}) :super(hours: hours, minutes: minutes);

  TaskDuration.fromDuration(Duration duration) : super(minutes: duration.inMinutes);

  @override
  String toString() {
    List<String> parts = [];
    if (this.inHours > 0)
      parts.add('${this.inHours}h');
    if (this.inMinutes % 60 > 0)
      parts.add('${this.inMinutes % 60}m');
    return parts.join(' ');
  }

  String toStringFull() {
    List<String> parts = [];
    if (this.inHours > 0)
      parts.add('${this.inHours} hours');
    if (this.inMinutes % 60 > 0)
      parts.add('${this.inMinutes % 60} minutes');
    return parts.join(', ');
  }

  @override
  TaskDuration operator +(TaskDuration other) {
    return TaskDuration.fromDuration(Duration(microseconds: this.inMicroseconds + other.inMicroseconds));
  }
}
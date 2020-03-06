import 'dart:async';

/**
 * !!!! Copied from dart-sdk and extended for both T and List<T>. See EventSink<T> for original declaration.
 * A [Sink] that supports adding errors.
 *
 * This makes it suitable for capturing the results of asynchronous
 * computations, which can complete with a value or an error.
 *
 * The [EventSink] has been designed to handle asynchronous events from
 * [Stream]s. See, for example, [Stream.eventTransformed] which uses
 * `EventSink`s to transform events.
 */
abstract class EventEntitySink<T> {
  /**
   * Adds a data [event] to the sink.
   *
   * Must not be called on a closed sink.
   */
  void add(T event);
  /**
   * Adds a data [listEvent] to the sink.
   *
   * Must not be called on a closed sink.
   */
  void addList(List<T> listEvent);

  /**
   * Adds an [error] to the sink.
   *
   * Must not be called on a closed sink.
   */
  void addError(Object error, [StackTrace stackTrace]);
  /**
   * Adds an [listError] to the sink.
   *
   * Must not be called on a closed sink.
   */
  void addListError(Object error, [StackTrace stackTrace]);

  /**
   * Closes both sinks.
   *
   * Calling this method more than once is allowed, but does nothing.
   *
   * Neither [add] nor [addError] with corresponding List alternatives must be called after this method.
   */
  void close();
}
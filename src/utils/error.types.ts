export class StartConferenceError extends Error {
  public type: 'alert' | 'exception';
  constructor(message: string, type: 'alert' | 'exception' = 'exception') {
    super(message);
    this.type = type;
  }
}

export class TerminateConferenceError extends Error {}

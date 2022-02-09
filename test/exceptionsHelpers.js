const errorString =
  "Transaction: 0x7b0f9d70e064713b5c848098c9a8b464bf81995e287973818b001e274ef59c5e exited with an error (status 0).";

async function tryCatch(promise) {
  try {
    await promise;
    throw null;
  } catch (error) {
    assert.equal(
      error.message,
      errorString,
      "Expected an error containing '" +
        errorString +
        "' but got '" +
        error.message +
        "' instead"
    );
  }
}

module.exports = {
  catchRevert: async function (promise) {
    await tryCatch(promise);
  },
  catchOutOfGas: async function (promise) {
    await tryCatch(promise, "out of gas");
  },
  catchInvalidJump: async function (promise) {
    await tryCatch(promise, "invalid JUMP");
  },
  catchInvalidOpcode: async function (promise) {
    await tryCatch(promise, "invalid opcode");
  },
  catchStackOverflow: async function (promise) {
    await tryCatch(promise, "stack overflow");
  },
  catchStackUnderflow: async function (promise) {
    await tryCatch(promise, "stack underflow");
  },
  catchStaticStateChange: async function (promise) {
    await tryCatch(promise, "static state change");
  },
};

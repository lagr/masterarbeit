var starsky = require('starsky');
var Ajv = require('ajv');
var ajv = Ajv();

var consumer = starsky.consumer('validator');
starsky.set({
  'mq host': 'wfms_mom_1',
  'mq port': 5672,
  'mq exchange': 'wfms'
});

function logError (err) { if (err) console.error(err.message); }

starsky.once('connect', function () {
  consumer.subscribe('wfms.*.input.#');
  consumer.subscribe('wfms.*.output.#');

  consumer.process(function (msg, done) {
  	try {
	  	var schema = msg.body['schema'];
	  	var data = msg.body['data'];

		var validate = ajv.compile(schema);
		var valid = validate(data);

		response = msg.body;
		response.valid = valid;
		if (!valid) response.errors = validate.errors;

		starsky.publish(msg.topic + '.' + valid.toString(), response, logError);

  	} catch (e) { console.error(e); }
    done();
  });
});

starsky.connect()

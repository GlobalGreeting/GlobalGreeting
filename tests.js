QUnit.module("Check Page Elements", function() {
    QUnit.test('Check 3 Page Elements', function(assert) {

        assert.ok($("#spanish").length !== 0, 'Spanish Link Exists');
        assert.ok($("#chinese").length !== 0, 'Chinese Link Exists');
        assert.ok($("#greek").length !== 0, 'Greek Link Exists');

    });
});

QUnit.module("Check Events-Change Language Selection", function() {


    QUnit.test('Chinese change', function(assert) {

        document.getElementById('chinese').click();
        assert.equal($("#result").text(), "你好", "Changed text to Chinese");
    });

    QUnit.test('Greek change', function(assert) {

        document.getElementById('greek').click();
        assert.equal($("#result").text(), "Χαίρετε", "Changed text to Greek");
    });

    QUnit.test('Spanish change', function(assert) {

        document.getElementById('spanish').click();
        assert.equal($("#result").text(), "Buenos Dias", "Changed text to Spanish");
    });
    
});

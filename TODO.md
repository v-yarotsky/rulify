* Multi-rules:

        when user.id is 5
        and user.age < 25 or user.age > 65
        then tutorial

        when none then no_tutorial

* API to defined input/output dictionaries

  Input dictionaries may feature types and computational complexity, i.e

        class UserInputs
          def initialize(user)
            @user = user
          end

          complexity 1
          type Numeric
          def id
            @user.id
          end
        end

  Outputs probably need to be restricted to a particular set to avoid confusion and allow better feedback while editing rules

* JS Editor for rules

  Should offer auto-complete from given dictionaries and highlight inputs based on computational complexity. Should as well auto-complete expression parts.
  Definitely should provide validation feedback.

* Rails integration (separate gem)

  Should provide easy-to-use components for editing/storing/using rules.


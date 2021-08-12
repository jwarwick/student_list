defmodule StudentListWeb.Live.Confirmation do
  @moduledoc """
  Data entered confirmation page
  """
  use Surface.Component
  alias StudentList.Directory.Listing

  prop support_email, :string, default: nil
  prop students, :any

  def render(assigns) do
    ~F"""
    <section class="hero is-primary">
      <div class="hero-body">
        <p class="title">
          Thanks!
        </p>
        <p class="subtitle">
          The information below has been submitted for the school directory.
        </p>
        <p :if={@support_email} class="subtitle">
          Questions or comments? Email <a href={"mailto:#{@support_email}?Subject=Support"}>{@support_email}</a>
        </p>
      </div>
    </section>

    <section>
    <div class="directory">
      <div class="students">
        {#for student <- @students}
        <div class="classroom">
          <div class="class_name">
            <h2 class="class_name">{student.class.name}</h2>
            <h3 class="teacher_name">{student.class.teacher}</h3>
          </div>
        </div>
       <div class="student_name_bus">
         <h4 class="student_name">{Listing.format_name(student.last_name)}, {Listing.format_name(student.first_name)}</h4>
         {#if student.bus.should_display}
           <span class="bus">{student.bus.name}</span><br>
         {/if}
         <br>
       </div>
           {#for address <- student.addresses}
             {#for parent <- address.adults}
              <div class="parent_name">
                <span><b>{Listing.format_name(parent.first_name)} {Listing.format_name(parent.last_name)}</b></span><br>
                <div class="parent_contact">
                  {#if Listing.not_empty(parent.email)}
                    <span class="email">{String.trim(parent.email)}</span><br>
                  {/if}
                  {#if Listing.not_empty(parent.mobile_phone)}
                    <span class="phone">Cell: {Listing.format_phone(parent.mobile_phone)}</span><br>
                  {/if}
                  <br>
                </div>
              </div>
            {/for}
            <div class="parent_address">
            </div>
              {#if Listing.not_empty(address.address1)}
                <span class="address_street">{String.trim(address.address1)}</span><br>
              {/if}
              {#if Listing.not_empty(address.address2)}
                <span class="address_street2">{String.trim(address.address2)}</span><br>
              {/if}
              {#if Listing.not_empty(address.city)}
                <span class="address_city">{String.trim(address.city)},</span>
              {/if}
              {#if Listing.not_empty(address.state)}
                <span class="address_state">{Listing.format_state(address.state)}  </span>
              {/if}
              {#if Listing.not_empty(address.zip)}
                <span class="address_zip">{String.trim(address.zip)}</span><br>
              {/if}
              {#if Listing.not_empty(address.phone)}
                <span class="home_phone">Home Phone: {Listing.format_phone(address.phone)}</span><br>
              {/if}
            <br>
          {/for}
          <p class="notes">{student.notes}</p>
          <br>
        {/for}
      </div>
    </div>
    </section>
    """
  end
end
